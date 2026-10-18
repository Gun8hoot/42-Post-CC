#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define FR_GREEN "\e[32m"
#define FR_RED   "\e[31m"
#define RESET    "\e[0m"

extern int ft_atoi_base(const char *str, const char *base);

/* If the bash passes an "integer-looking" base (2..36), convert it
   to the equivalent standard base string (e.g. "10" -> "0123456789"). */
static const char *normalize_base(const char *arg, char *buf, size_t bufsz)
{
	int all_digits = (*arg != '\0');
	for (const char *p = arg; *p; p++)
		if (!isdigit((unsigned char)*p)) { all_digits = 0; break; }

	if (!all_digits)
		return (arg);

	int n = atoi(arg);
	if (n < 2 || n > 36)
		return (arg);

	const char *digits = "0123456789abcdefghijklmnopqrstuvwxyz";
	if ((size_t)n + 1 > bufsz) return (arg);
	memcpy(buf, digits, n);
	buf[n] = '\0';
	return (buf);
}

int main(int argc, char **argv)
{
	if (argc != 4) return (2);

	char base_buf[64];
	const char *base = normalize_base(argv[2], base_buf, sizeof(base_buf));
	int base_len = (int)strlen(base);

	/* validate base */
	int valid = (base_len >= 2 && base_len <= 36);
	for (int i = 0; valid && i < base_len; i++)
	{
		unsigned char c = (unsigned char)base[i];
		if (c == '+' || c == '-' || isspace(c)) { valid = 0; break; }
		for (int j = i + 1; j < base_len; j++)
			if (base[i] == base[j]) { valid = 0; break; }
	}

	int got = ft_atoi_base(argv[1], base);

	if (!valid)
	{
		if (got != 0)
		{
			printf("%s[-] ft_atoi_base : %s invalid base must return 0, got %d\n%s",
				FR_RED, argv[3], got, RESET);
			return (1);
		}
		printf("%s[+] ft_atoi_base : %s passed!%s\n", FR_GREEN, argv[3], RESET);
		return (0);
	}

	/* compute expected */
	const char *s = argv[1];
	while (*s && isspace((unsigned char)*s)) s++;
	int sign = 1;
	if (*s == '+' || *s == '-') { if (*s == '-') sign = -1; s++; }

	long expected = 0;
	while (*s)
	{
		const char *p = strchr(base, *s);
		if (!p && isalpha((unsigned char)*s))
		{
			char other = islower((unsigned char)*s)
				? toupper((unsigned char)*s)
				: tolower((unsigned char)*s);
			p = strchr(base, other);
		}
		if (!p) break;
		expected = expected * base_len + (p - base);
		s++;
	}
	expected *= sign;

	if ((int)expected != got)
	{
		printf("%s[-] ft_atoi_base : %s result differ!\nExpected: %d\nGot: %d\n%s",
			FR_RED, argv[3], (int)expected, got, RESET);
		return (1);
	}
	printf("%s[+] ft_atoi_base : %s passed!%s\n", FR_GREEN, argv[3], RESET);
	return (0);
}
