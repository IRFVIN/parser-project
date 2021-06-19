{
 
    

    
    int a; int b;
    char c; boolean d;
    
    // should cause incompatible types 
    int e = 10.0;
    double j;
    
    char[] str = new char[100];
    
    ArrayList<int> arr = new ArrayList<int>();
    int[] x = new int[10];
    int[] hello = new int[100];
    
    ArrayList<int> arr1;    
    arr1 = new ArrayList<int>();
    
    // valid foreach loop
    for (int elem : arr) {
        a = a * b + elem;
    }
    
    // should cause d is not a sequence
    for (int g : d) {
        a = a + 1;
    }
    

    x[0] = 12;
    x[1] = 13;
    x[2] = 16;
    
    // should cause incompatible types int and double
    x[3] = 19.87;
    
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
    
    // should cause "a" is not a sequence"
    for (int element : a) {
        a = a + 1;
    }
    
    // should cause incompatible types int and char
    for (int ele : str) {
        ele = ele + 1;
    }
    
}
