extern int helper(int n, int acc);

int sum_tail(int n, int acc) {
    if (n == 0)
        return acc;
    return helper(n - 1, acc + n);
}
