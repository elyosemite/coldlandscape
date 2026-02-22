#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define INITIAL_CAP 8
#define MAX_LINE    1024

typedef struct {
    char  **data;
    size_t  size;
    size_t  capacity;
} StringVec;

static int vec_init(StringVec *v) {
    v->data = malloc(INITIAL_CAP * sizeof(char *));
    if (!v->data) return -1;
    v->size     = 0;
    v->capacity = INITIAL_CAP;
    return 0;
}

static int vec_push(StringVec *v, const char *s) {
    if (v->size == v->capacity) {
        size_t new_cap = v->capacity * 2;
        char **tmp = realloc(v->data, new_cap * sizeof(char *));
        if (!tmp) return -1;
        v->data     = tmp;
        v->capacity = new_cap;
    }
    v->data[v->size] = strdup(s);
    if (!v->data[v->size]) return -1;
    v->size++;
    return 0;
}

static void vec_free(StringVec *v) {
    for (size_t i = 0; i < v->size; i++)
        free(v->data[i]);
    free(v->data);
    v->data     = NULL;
    v->size     = 0;
    v->capacity = 0;
}

static int read_lines(const char *path, StringVec *out) {
    FILE *f = fopen(path, "r");
    if (!f) {
        fprintf(stderr, "error opening %s: %s\n", path, strerror(errno));
        return -1;
    }

    char buf[MAX_LINE];
    while (fgets(buf, sizeof(buf), f)) {
        size_t len = strlen(buf);
        if (len > 0 && buf[len - 1] == '\n')
            buf[len - 1] = '\0';
        if (vec_push(out, buf) != 0) {
            fclose(f);
            return -1;
        }
    }

    fclose(f);
    return 0;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "usage: %s <file>\n", argv[0]);
        return EXIT_FAILURE;
    }

    StringVec lines;
    if (vec_init(&lines) != 0) {
        perror("vec_init");
        return EXIT_FAILURE;
    }

    if (read_lines(argv[1], &lines) != 0) {
        vec_free(&lines);
        return EXIT_FAILURE;
    }

    printf("Read %zu lines from '%s':\n", lines.size, argv[1]);
    for (size_t i = 0; i < lines.size; i++)
        printf("  %4zu | %s\n", i + 1, lines.data[i]);

    vec_free(&lines);
    return EXIT_SUCCESS;
}
