

Le programme de résolution du Sudoku utilise un algorithme récursif qui combine déduction et exploration.

L'aspect déduction vise d'une part à découvrir les cases pour lesquelles, étant donnés les chiffres connus ou supposés, un seul chiffre est possible, et d'autre part les chiffres pour lesquels une seule case est possible au sein d'une ligne, colonne ou d'un carré.

L'aspect exploration quant à lui fait des hypothèses sur les cases pour lesquels plusieurs chiffres sont encore possible et travaille à partir de ça en relançant une phase de déduction ou d'hypothèse. Si pour une hypothèse donnée la résolution s'avère impossible, généralement parce qu'on tombe sur une case avec zéro solution, le chiffre suivant est testé. Si tous les chiffres ont été testés sans succès, l'hypothèse faite sur le case précédente est revue et le chiffre suivant est testé pour cette case.

Pour une grille simple, il se peut qu'il ne soit pas nécessaire de faire des hypothèses, la résolution par déduction étant suffisante.

