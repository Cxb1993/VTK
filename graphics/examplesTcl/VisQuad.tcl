catch {load vtktcl}
source vtkInt.tcl

vtkRenderMaster rm

# create a window to render into
set renWin [rm MakeRenderWindow]

# create a renderer
set ren1 [$renWin MakeRenderer]

# interactiver renderer catches mouse events (optional)
set iren [$renWin MakeRenderWindowInteractor]

# Quadric definition
  vtkQuadric quadric
    quadric SetCoefficients .5 1 .2 0 .1 0 0 .2 0 0

  vtkSampleFunction sample
    sample SetSampleDimensions 30 30 30
    sample SetImplicitFunction quadric
    sample Update
    sample Print
    
# Create five surfaces F(x,y,z) = constant between range specified
  vtkContourFilter contours
    contours SetInput [sample GetOutput]
    contours GenerateValues 5 0.0 1.2

  vtkPolyMapper contMapper
    contMapper SetInput [contours GetOutput]
    contMapper SetScalarRange 0.0 1.2

  vtkActor contActor
    contActor SetMapper contMapper

# Create outline
  vtkOutlineFilter outline
    outline SetInput [sample GetOutput]

  vtkPolyMapper outlineMapper
    outlineMapper SetInput [outline GetOutput]

  vtkActor outlineActor
    outlineActor SetMapper outlineMapper
    eval [outlineActor GetProperty] SetColor 0 0 0

  $ren1 SetBackground 1 1 1
  $ren1 AddActor contActor
  $ren1 AddActor outlineActor

$iren SetUserMethod {wm deiconify .vtkInteract}
$iren Initialize

#$renWin SetFileName VisQuad.tcl.ppm
#$renWin SaveImageAsPPM

wm withdraw .
