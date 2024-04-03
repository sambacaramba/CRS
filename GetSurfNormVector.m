% Copyright 2024 Sami Kauppinen (sami.kauppinen(at)oulu.fi)
function surfacenormal_vector = GetSurfNormVector(surface)

[ surface_plane, dummy] = SurFitFix( surface, 1, 1);

[Nx,Ny,Nz] = surfnorm(surface_plane); 

Nx = mean(Nx(:));
Ny = mean(Ny(:));
Nz = mean(Nz(:));

surfacenormal_vector = [Nx, Ny, Nz];