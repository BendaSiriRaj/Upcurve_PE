public class Practice1 {
    static int daysInMonth(int month){
        if(month<1 || month>12){
            throw new IllegalArgumentException("invalid value was supplied");
        }
        if(month==4 || month==6 || month==9 || month==11){
            return 30;
        }
        if(month==2){
            return 28;
        }
        return 31;
    }
    
    static int square(int num){
        System.out.println("square was called with "+num);
        return num*num;
    }

    static boolean isEven(int num){
        return num%2==0;
    }

    public static void main(String[] args){
        System.out.println("Control Flow Demo");

        var n= 1230;
        var sq=square(n);

        var sqrt=Math.sqrt(n);

        System.out.printf("Square of %d is %d\n",n,sq);
        System.out.printf("Square root of %d is %f\n",n,sqrt);

        if(isEven(n)){
            System.out.printf("%d is an even number.",n);
        }
        else{
            System.out.printf("%d is an odd number.",n);
        }

        var m=91;
        var days = daysInMonth(m);
        System.out.printf("the month %d has %d days\n",m,days);

        System.out.println("End of main()");
    }
}
