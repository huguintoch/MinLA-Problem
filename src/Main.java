import gurobi.GRBException;

import java.io.File;
import java.util.Scanner;

public class Main {

    private static int n;
    private static int[][] dist;

    private static void readGra(String path) {
        int[] deg;

        try {
            Scanner scan = new Scanner(new File(path));

            String line = scan.nextLine();
            String[] tokens = line.split("\\s+");

            n = Integer.parseInt(tokens[0]);
            scan.nextInt();

            deg = new int[n];
            dist = new int[n][n];

            for (int i = 0; i < n; i++) {
                deg[i] = scan.nextInt();
            }

            int cumul = 0, j;
            for (int i = 0; i < n; i++) {
                for (int k = cumul; k < cumul + deg[i]; k++) {
                    j = scan.nextInt();
                    dist[i][j] = dist[j][i] = 1;
                }
                cumul += deg[i];
            }

            scan.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Failed to read input file");
            System.exit(0);
        }
    }

    public static void readDIMACS(String path) {
        try {
            Scanner scan = new Scanner(new File(path));

            while (scan.hasNextLine()) {
                String line = scan.nextLine();
                String[] tokens = line.split("\\s+");

                if (tokens.length > 0) {
                    if (tokens[0].equals("c"))
                        continue;
                    if (tokens.length == 2) {
                        n = Integer.parseInt(tokens[0]);
                        dist = new int[n][n];
                    } else if (tokens.length == 3) {
                        int u = Integer.parseInt(tokens[0]) - 1;
                        int v = Integer.parseInt(tokens[1]) - 1;
                        dist[u][v] = dist[v][u] = 1;
                    }
                }
            }

            scan.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Failed to read input file");
            System.exit(0);
        }
    }

    public static void main(String[] args) throws GRBException {
        if (args.length < 2) {
            System.out.println("Arguments needed :\n\tfilename\n\tgra/dimacs\n\t[timeLimit]");
            return;
        }

        if (args[1].equals("gra")) readGra(args[0]);
        else readDIMACS(args[0]);

        int timeLimit = Integer.MAX_VALUE;
        if (args.length == 3)
            timeLimit = Integer.parseInt(args[2]);

        Model mip = new Model(n, dist);

        System.out.println("MIP model created");
        System.out.println("Solving...");

        mip.solve(timeLimit);
        mip.dispose();
    }

}
