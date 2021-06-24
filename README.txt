

Le programme de résolution du Sudoku utilise un algorithme récursif qui combine déduction et exploration.

L'aspect déduction vise d'une part à découvrir les cases pour lesquelles, étant donnés les chiffres connus ou supposés, un seul chiffre est possible, et d'autre part les chiffres pour lesquels une seule case est possible au sein d'une ligne, colonne ou d'un carré.

L'aspect exploration quant à lui fait des hypothèses sur les cases pour lesquels plusieurs chiffres sont encore possible et travaille à partir de ça en relançant une phase de déduction ou d'hypothèse. Si pour une hypothèse donnée la résolution s'avère impossible, généralement parce qu'on tombe sur une case avec zéro solution, le chiffre suivant est testé. Si tous les chiffres ont été testés sans succès, l'hypothèse faite sur le case précédente est revue et le chiffre suivant est testé pour cette case.

Pour une grille simple, il se peut qu'il ne soit pas nécessaire de faire des hypothèses, la résolution par déduction étant suffisante.


Le programme maintient en permanence tous les chiffres possibles dans chacune des cases étant donnés les chiffres connus ou supposés, selon les règles du Sudoku. Lorsqu'un chiffre est supposé, les possibilités dans les cases liées sont mise à jour.

L'algorithme est le suivant :

00. Chercher les cases pour lesquelles il n'y a pas de solution
00. Pour la première case trouvée, terminer sur un échec

1. Chercher les cases pour lesquelles il n'y a qu'un seule solution
2. Pour la première case trouvée, placer le chiffre et terminer sur le résultat de l'algorithme relancé

3. Chercher les chiffres ne pouvant apparaitre que dans une seule case au sein d'une ligne, colonne ou d'un carré
4. Pour le premier chiffre trouvé, placer le chiffre dans la case et terminer sur le résultat de l'algorithme relancé

5. Trouver la première case encore vide
6. S'il n'y a plus de cases vide, le Soduku est résolu, terminer sur une réussite

x. S'il

7. Pour chacun des chiffres possibles dans la case
	7.1. Placer le chiffre et relancer l'algorithme
	7.2. Si l'algorithme réussit, terminer sur une réussite
	7.3. Si l'algorithme échoue, continuer la boucle
8. Si tous les chiffres ont été testés sans succès, terminer sur un échec

