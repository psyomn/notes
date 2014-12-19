% Cargo Architecture
% Simon Symeonidis
% Thu Dec 18 21:08:06 EST 2014

# Introduction

These are personal notes investigating the inner workings of Cargo. The scope of
this document is detecting the components which fetch in dependencies, and how
the compilation process is invoked. We conclude on mechanisms that can be used
in order to intercept compilation procedure, in order to implement modular
tools, as plugins for Cargo.

<!--- TODO: The above last sentence should be checked again -->

# Background

