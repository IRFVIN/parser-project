{
 
    

    
    int a; int b;
    char c; boolean d;
    int e;
    double j;
    
    ArrayList<int> arr = new ArrayList<int>();
    int[] x = new int[10];
    int[] hello = new int[100];
    
    ArrayList<int> arr1;    
    arr1 = new ArrayList<int>();
    
    for (int elem : arr) {
        a = a * b + elem;
    }
    
    // should cause incompatible types boolean and int
    for (int g : d) {
        a = a + 1;
    }
    

    x[0] = 12;
    x[1] = 13;
    x[2] = 16;
    
    e = 10;
    
    // incompatible types boolean and int
    d = 10 + 20 * 30;
    
    // should cause f is not declared
    a = b + e + f;
    
    // should cause incompatible types double and int
    j = 10;
    
    j = 10.23; // ok
    
    // should cause redeclaration of x
    for (int x : arr) a = a + 1;
    
    // should cause "a: not a sequence error"
    for (int element : a) {
        a = a + 1;
    }
    
}
