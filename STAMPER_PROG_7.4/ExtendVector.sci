function vOut = ExtendVector(vIn, vExtendTo)
    [fX, fY] = IntersectionPoint(vIn, vExtendTo);
    vOut = [vIn(1,:); [fX,fY]];
endfunction

function [Px, Py] = IntersectionPoint(L1, L2)
    a = det(L1);
    b = det(L2);
    
    c = det([L1(:,1), [1;1]]);
    d = det([L2(:,1), [1;1]]);    
    e = det([L1(:,2), [1;1]]);
    f = det([L2(:,2), [1;1]]);
    
//    printf("a = %f\n", a);
//    printf("b = %f\n", b);
//    printf("c = %f\n", c);
//    printf("d = %f\n", d);
//    printf("e = %f\n", e);
//    printf("f = %f\n", f);    

    g = det([c, e; d, f]);
    h = det([c, e; d, f]);
    
//    printf("g = %f\n", g);
//    printf("h = %f\n", h);
    
    Px = det([a, c; b, d]) / g;
    Py = det([a, e; b, f]) / h;
endfunction
