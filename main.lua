local donjon = {}
donjon.nombreDeColonnes  = 9
donjon.nombreDeLignes = 6
donjon.salleDepart = nil
donjon.map = {}

function CreerSalle(pLigne, pColonne)
	local newSalle = {}

	newSalle.ligne = pLigne
	newSalle.colonne = pColonne

	newSalle.estOuverte = false

	newSalle.porteHaut = false
	newSalle.porteDroite = false
	newSalle.porteBas = false
	newSalle.porteGauche = false

	return newSalle

end

function GenererDonjon()	
	donjon.map = {}

	local nLigne, nColonne

	for nLigne=1, donjon.nombreDeLignes do
		donjon.map[nLigne] = {}

		for nColonne=1, donjon.nombreDeColonnes do
			donjon.map[nLigne][nColonne] = CreerSalle(nLigne, nColonne)
		end

	end

	-- Génération du Donjon
	local listeSalles = {}
	local nbSalles= 20

	-- Création de la salle de départ
	local nLigneDepart, nColonneDepart
	nLigneDepart = math.random(1, donjon.nombreDeLignes)
	nColonneDepart = math.random(1, donjon.nombreDeColonnes)
	local salleDepart = donjon.map[nLigneDepart][nColonneDepart]
	salleDepart.estOuverte = true
	table.insert(listeSalles, salleDepart)

	-- Mémoriser la salle de départ 
	donjon.salleDepart = salleDepart

	while #listeSalles < nbSalles do
		--Sélection d'une salle dans la liste
		local nSalle = math.random(1, #listeSalles)
		local nLigne = listeSalles[nSalle].ligne
		local nColonne = listeSalles[nSalle].colonne
		local salle = listeSalles[nSalle]
		local newSalle = nil

		-- Sélection d'une direction pour positionner la nouvelle salle
		local direction = math.random(1, 4)

		-- Booléen pour ajouter la salle ou non
		local bAjouteSalle = false

		-- Si la direction est orientée vers le haut, et que l'on a une ligne au dessus de la ligne actuelle alors...
		if direction == 1 and nLigne > 1 then
			-- On créé la salle en se positionnant sur la ligne au dessus de la ligne de la salle actuelle.
			newSalle = donjon.map[nLigne-1][nColonne]
			-- Si la potentielle nouvelle salle n'est pas déjà ouverte alors...
			if newSalle.estOuverte == false then
				-- Création d'une porte haut dans la salle actuelle.
				salle.porteHaut = true
				-- Création d'une porte bas dans la nouvelle salle.
				newSalle.porteBas = true
				-- La nouvelle salle peut être ajouté.
				bAjouteSalle = true
			end

		-- Sinon si la direction est orientée vers la droite, et que l'on a une colonne à droite de la colonne actuelle alors...
		elseif direction == 2 and nColonne < donjon.nombreDeColonnes then
			-- On créé la salle en se positionnant sur la colonne à droite de la colonne de la salle actuelle.
			newSalle = donjon.map[nLigne][nColonne+1]
			-- Si la potentielle nouvelle salle n'est pas déjà ouverte alors...
			if newSalle.estOuverte == false then
				-- Création d'une porte droite dans la salle actuelle.
				salle.porteDroite = true
				-- Création d'une porte gauche dans la nouvelle salle.
				newSalle.porteGauche = true
				-- La nouvelle salle peut être ajouté.
				bAjouteSalle = true
			end

		-- Sinon si la direction est orientée vers le bas, et que l'on a une ligne en dessous de la ligne actuelle alors...
		elseif direction == 3 and nLigne < donjon.nombreDeLignes then
			-- On créé la salle en se positionnant sur la ligne en dessous de la ligne de la salle actuelle.
			newSalle = donjon.map[nLigne+1][nColonne]
			-- Si la potentielle nouvelle salle n'est pas déjà ouverte alors...
			if newSalle.estOuverte == false then
				-- Création d'une porte bas dans la salle actuelle.
				salle.porteBas = true
				-- Création d'une porte haut dans la nouvelle salle.
				newSalle.porteHaut = true
				-- La nouvelle salle peut être ajouté.
				bAjouteSalle = true
			end

		-- Sinon si la direction est orientée vers la gauche, et que l'on a une colonne à gauche de la colonne actuelle alors...
		elseif direction == 4 and nColonne > 1 then
			-- On créé la salle en se positionnant sur la colonne à gauche de la colonne de la salle actuelle.
			newSalle = donjon.map[nLigne][nColonne-1]
			-- Si la potentielle nouvelle salle n'est pas déjà ouverte alors...
			if newSalle.estOuverte == false then
				-- Création d'une porte gauche dans la salle actuelle.
				salle.porteGauche = true
				-- Création d'une porte droite dans la nouvelle salle.
				newSalle.porteDroite = true
				-- La nouvelle salle peut être ajouté.
				bAjouteSalle = true
			end
		end

		-- Ajout des nouvelles salles
		if bAjouteSalle == true then
			newSalle.estOuverte = true
			table.insert(listeSalles, newSalle)
		end

	end

end

function love.load()
  
  GenererDonjon()
  
end

function love.update(dt)

	

end

function love.draw()
  
  	-- Permet de s'éloigner du bord du tableau pour créer une bordure
	local x,y
	x = 5
	y = 5

	local largeurCase = 34
	local hauteurCase = 13
	local espaceCase = 5

	-- Dessin de la map du donjon
	for nLigne=1, donjon.nombreDeLignes do
		x = 5

		for nColonne=1, donjon.nombreDeColonnes do
			local salle = donjon.map[nLigne][nColonne]
			-- Si la salle n'a jamais été visité on met la case en gris foncé
			if salle.estOuverte == false then
				love.graphics.setColor(0.1, 0.1, 0.1)
			else
				-- Si la salle est la salle de départ la case est verte
				if donjon.salleDepart == salle then
					love.graphics.setColor(0.1, 1, 0.1)
				else
					-- Si la salle a déjà été visité on dessine la case en blanc
					love.graphics.setColor(1, 1, 1)
				end
			end
			-- Dessine la salle
			love.graphics.rectangle("fill", x, y, largeurCase, hauteurCase)

			-- Couleur des portes : rouges
			love.graphics.setColor(1, 0.5, 0.5)
			-- Si la salle a une porte vers le haut alors dessine la porte
			if salle.porteHaut == true then
				love.graphics.rectangle("fill", (x+largeurCase/2)-2, y-2, 4, 6)
			end
			-- Si la salle a une porte vers la droite alors dessine la porte
			if salle.porteDroite == true then
				love.graphics.rectangle("fill", (x+largeurCase)-2, (y+hauteurCase/2)-2, 6, 4)
			end
			-- Si la salle a une porte vers le base alors dessine la porte
			if salle.porteBas == true then
				love.graphics.rectangle("fill", (x+largeurCase/2)-2, (y+hauteurCase)-2, 4, 6)
			end
			-- Si la salle a une porte vers la gauche alors dessine la porte
			if salle.porteGauche == true then
				love.graphics.rectangle("fill", (x-2), (y+hauteurCase/2)-2, 6, 4)
			end

			x = x + largeurCase + espaceCase

		end
		y = y + hauteurCase + espaceCase

	end

	-- Remise en blanc de la couleur par défaut pour éviter aux cases du traitement suivant de rencontrer un problème avec les couleurs.
	love.graphics.setColor(0, 0, 0)

end

function love.keypressed(key)
  if key == "space" or key == " " then
  	GenererDonjon()
  end

  
end
  