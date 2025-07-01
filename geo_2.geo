SetFactory("OpenCASCADE");

//-----------------------------------------
// (1) Base geométrica
//-----------------------------------------

Rectangle(1) = {-6, -6, -6, 156, 32};
Rectangle(2) = {-6, 26, -6, 97, 268};

sBase[] = BooleanUnion { Surface{1}; Delete; } { Surface{2}; Delete; };

extrBase[] = Extrude {0,0,74} {
    Surface{sBase[0]};
    Layers{1};
};

//-----------------------------------------
// (2) Primer volumen de corte
//-----------------------------------------

Point(100) = {0,354,0};
Point(101) = {85,354,0};
Point(102) = {0,354,62};
Point(103) = {85,354,62};

Line(100) = {100,101};
Line(101) = {101,103};
Line(102) = {103,102};
Line(103) = {102,100};

Curve Loop(100) = {100,101,102,103};
Plane Surface(100) = {100};

extr2[] = Extrude {0,-334-10,0} {
    Surface{100};
    Layers{1};
};

//-----------------------------------------
// (3) Primera diferencia
//-----------------------------------------

vDiff1[] = BooleanDifference{
    Volume{extrBase[1]}; Delete;
}{
    Volume{extr2[1]}; Delete;
};

//-----------------------------------------
// (4) Segundo volumen de corte
//-----------------------------------------

Point(200) = {160,0,0};
Point(201) = {160,20,0};
Point(202) = {160,0,62};
Point(203) = {160,20,62};

Line(200) = {200,201};
Line(201) = {201,203};
Line(202) = {203,202};
Line(203) = {202,200};

Curve Loop(200) = {200,201,202,203};
Plane Surface(200) = {200};

extr3[] = Extrude {-160,0,0} {
    Surface{200};
    Layers{1};
};

//-----------------------------------------
// (5) Segunda diferencia
//-----------------------------------------

vDiff2[] = BooleanDifference{
    Volume{vDiff1[0]}; Delete;
}{
    Volume{extr3[1]}; Delete;
};

//-----------------------------------------
// (6) Resultado final
//-----------------------------------------

Physical Volume("Solido") = {vDiff2[0]};

//-----------------------------------------
// (6) Ahora creo el volumewn Liquido
//-----------------------------------------


Point(1000) = {0,294,0};
Point(1010) = {85,294,0};
Point(1020) = {0,294,62};
Point(1030) = {85,294,62};

Line(1000) = {1000,1010};
Line(1010) = {1010,1030};
Line(1020) = {1030,1020};
Line(1030) = {1020,1000};

Curve Loop(1000) = {1000,1010,1020,1030};
Plane Surface(1000) = {1000};

extr4[] = Extrude {0,-294-5,0} {
    Surface{1000};
    Layers{1};
};

Point(2000) = {150,0,0};
Point(2010) = {150,20,0};
Point(2020) = {150,0,62};
Point(2030) = {150,20,62};

Line(2000) = {2000,2010};
Line(2010) = {2010,2030};
Line(2020) = {2030,2020};
Line(2030) = {2020,2000};

Curve Loop(2000) = {2000,2010,2020,2030};
Plane Surface(2000) = {2000};

extr5[] = Extrude {-150,0,0} {
    Surface{2000};
    Layers{1};
};

vUnion[] = BooleanUnion{
    Volume{extr4[1]}; Delete;
}{
    Volume{extr5[1]}; Delete;
};

//-----------------------------------------
// (9) Grupo físico del líquido
//-----------------------------------------
Physical Volume("Liquido") = {vUnion[0]};

Mesh 3;
