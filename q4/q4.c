#include<stdio.h>
#include<stdlib.h>
#include<dlfcn.h>
#include<string.h>

int main(){
    char op[7];
    int a,b;

    while(scanf("%s %d %d", op, &a, &b)!=EOF){
        char libraryname[25];
        strcpy(libraryname, "lib");
        strcat(libraryname, op);
        strcat(libraryname, ".so");

        void* library = dlopen(libraryname, RTLD_LAZY); //Lazy Loading
        if(library==NULL){
            printf("Error in loading %s\n", libraryname);
            continue;
        }

        int (*function)(int, int);  //Function pointer
        function = (int (*)(int, int)) dlsym(library, op);
        if(function==NULL){
            printf("Function %s is not available\n", op);
            dlclose(library);
            continue;
        }

        int c = function(a,b);
        printf("%d\n", c);

        dlclose(library);
    }   

    return 0;
}
