# Plot Junctions, a tool for plotting band diagrams

## Rationale
When designing solar devices, testing large sets of materials is costly because a batch of test devices must be fabricated for each combination of materials.

## Materials Library
Plot Junctions contains a few materials in its materials library to make getting started easier. Import the data from the library, and if you like, modify it before the program plots 

## Developer
### Modular Design
Plot Junctions can be split roughly into a frontend and a backend. The frontend is the `plotjunctions_gui()`: it manages the user interface and receives input from the user. The frontend then takes the user's input and hands it off to the backend, which is a loosely coupled set of classes that collectively carry out all of the program's responsibilities. This modular design allows flexibility and makes future expansion easy: to add support for a new material or junction type, just write a new class that conforms to the spec.
