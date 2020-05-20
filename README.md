# minla-mip

Implementation with Gurobi of the latest MIP model for the Minimum Linear Arrangement (MinLA) presented in the [article](https://www.sciencedirect.com/science/article/abs/pii/S1571065317302500) :

> Andrade, R., Bonates, T., Campêlo, M., & Ferreira, M. (2017). Minimum Linear Arrangements. _Electronic Notes in Discrete Mathematics_, 62, 63-68.

It also includes benchmark instances used to evaluate the performances of solvers for the MinLA.

## Help

```
Arguments needed :
        filename
        gra/dimacs
        [timeLimit]
```
Where `gra` and `dimacs` are 2 different input graphs file format.

## Dependencies

Currently works with [Gurobi](https://www.gurobi.com/) 9.0.1, all you need is to import the `gurobi.jar` file in your [IntelliJ](https://www.jetbrains.com/fr-fr/idea/) project and grab an Academic License for the optimizer.
