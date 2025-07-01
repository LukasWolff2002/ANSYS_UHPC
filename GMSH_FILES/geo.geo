SetFactory("OpenCASCADE");

// Crear los dos rectángulos
Rectangle(1) = {-6, -6, -6, 156, 32, -6};
Rectangle(2) = {-6, 26, -6, 97, 280-12, -6};

// Unirlos
BooleanUnion{ Surface{1}; Delete; }{ Surface{2}; Delete; }

v[] = Extrude {0,0,74} {
    Surface{1};
    Layers{1};
    Recombine;
};

// Crear un grupo físico con el volumen
Physical Volume("Solido") = {v[1]}; 

//Creo el rectangulo superios
Point(1) = {0, 294, 0, 1.0};
Point(2) = {97-12, 294, 0, 1.0};
Point(3) = {0, 294, 62, 1.0};
Point(4) = {97-12, 294, 62, 1.0};

Line(1) = {1,2};
Line(2) = {2,4};
Line(3) = {4,3};
Line(4) = {3,1};


// Contorno cerrado
Curve Loop(10) = {1,2,3,4};

// Superficie
Plane Surface(100) = {10};

extr2[] = Extrude {0,-274,0} {
    Surface{100};
    Layers{1};
    Recombine;
};

Point(100) = {150, 0, 0, 1.0};
Point(101) = {150, 20, 0, 1.0};
Point(102) = {150, 0, 62, 1.0};
Point(103) = {150, 20, 62, 1.0};

Line(100) = {100,101};
Line(101) = {101,103};
Line(102) = {103,102};
Line(103) = {102,100};

Curve Loop(100) = {100, 101, 102, 103};
Plane Surface(200) = {100};

extr3[] = Extrude {-150,0,0} {
    Surface{200};
    Layers{1};
    Recombine;
};

vUnion[] = BooleanUnion {
    Volume{extr2[1]}; Delete;
} {
    Volume{extr3[1]}; Delete;
};

// Hacer la resta
vDiff[] = BooleanDifference {
    Volume{v[1]}; Delete;
} {
    Volume{vUnion[0]}; // OJO: no pones Delete aquí
};

// Definir grupo físico para el sólido "perforado"
Physical Volume("SolidoPerforado") = {vDiff[0]};

// Mantener el volumen que se restó
Physical Volume("VolumenResta") = {vUnion[0]};


