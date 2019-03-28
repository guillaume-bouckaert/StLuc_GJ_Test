debug = true

--[[PARAMETRES DU JEU]]

--[[PARAMETRES DU JOUEUR]]
vitesse_horizontale_joueur = 150
vitesse_verticale_joueur = 150
vitesse_projectile = 250

--[[PARAMETRES DES ENNEMIES]]
vitesse_mechant1 = 350
vitesse_mechant2 = 265

--[[PARAMETRES DE L'ENVIRONNEMENT]]
vitesse_nuage = 145
vitesse_ciel = 75


--[[IMPORTANT STUFFS - DONT TOUCH]]
inGame = false
inScore = false
score = 0

titre = {x = 112, y = 336, img = nil}
tutoriel = {x = 112, y = 536, img = nil}

rejouer = {x = 112, y = 536, img = nil}

player = {x = 200, y = 700, img = nil}

isAlive = true
score = 0

canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

bullet_image = nil

bullets = {}

createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax

enemy1_image = nil
enemy2_image = nil
enemy3_image = nil

enemies = {}

createCloudTimerMax = 0.6
createCloudTimer = createCloudTimerMax

cloud_image = nil

clouds = {}

background_image = nil

backgrounds = {}

function CheckCollision(x1,y1,w1,h1,x2,y2,w2,h2)
	return x1 < x2 + w2 and
			x2 < x1 + w1 and
			y1 < y2 + h2 and
			y2 < y1 + h1

end

function love.load(arg)

	titre.img = love.graphics.newImage('images/image_titre.png')
	tutoriel.img = love.graphics.newImage('images/image_tutoriel.png')
	rejouer.img = love.graphics.newImage('images/image_rejouer.png')

	player.img = love.graphics.newImage('images/image_joueur.png')

	bullet_image = love.graphics.newImage('images/image_projectile.png')

	enemy1_image = love.graphics.newImage('images/image_mechant1.png')
	enemy2_image = love.graphics.newImage('images/image_mechant2.png')

	cloud_image = love.graphics.newImage('images/image_nuage.png')

	background_image = love.graphics.newImage('images/image_ciel.png')

	background_counter = 0

	for i=1,3 do
		newBackground = {x = - (background_image:getWidth()/2) + (love.graphics.getWidth()/2), y = - (background_image:getHeight()/2) + (love.graphics.getHeight()/2) - (love.graphics.getHeight() * background_counter), img = background_image}
		table.insert(backgrounds,newBackground)
		background_counter = background_counter + 1
	end
end 

function StartGame()
	
	inGame = true
	inScore = false

	isAlive = true
	score = 0

	player.x = (love.graphics.getWidth()/2) - player.img:getWidth()/2
	player.y = (love.graphics.getHeight()/2) - player.img:getHeight()/2

	bullets= {}
	enemies = {}

	canShootTimer = canShootTimerMax
	createEnemyTimer = createEnemyTimerMax
end

function UpdateInGame(dt)
	
	if love.keyboard.isDown('left','a') then
		if player.x > 0 then
			player.x = player.x - (vitesse_horizontale_joueur * dt)
		end
	elseif love.keyboard.isDown('right','d') then
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = player.x + (vitesse_horizontale_joueur * dt)
		end
	end

	if love.keyboard.isDown('up','z') then
		if player.y > 0 then
			player.y = player.y - (vitesse_verticale_joueur * dt)
		end
	elseif love.keyboard.isDown('down','s') then
		if player.y < (love.graphics.getHeight() - player.img:getHeight()) then
			player.y = player.y + (vitesse_verticale_joueur * dt)
		end
	end

	canShootTimer = canShootTimer - (1 * dt)
	if canShootTimer < 0 then
		canShoot = true
	end

	if love.keyboard.isDown ('space','rctrl','lctrl','ctrl') and canShoot then
		newBullet = {x = player.x + (player.img:getWidth()/2) - (bullet_image:getWidth()/2), y = player.y, img = bullet_image}
		table.insert(bullets,newBullet)
		canShoot = false
		canShootTimer = canShootTimerMax
	end

	for i,bullet in ipairs(bullets) do
		bullet.y = bullet.y - (vitesse_projectile * dt)

		if bullet.y < 0 then
			table.remove(bullets,i)
		end
	end

	createEnemyTimer = createEnemyTimer - (1 * dt)
	if createEnemyTimer < 0 then
		createEnemyTimer = createEnemyTimerMax

		enemyType = math.random(1,2)
		newEnemy = nil

		if enemyType == 1 then
			randomNumber = math.random(enemy1_image:getWidth()/2,love.graphics.getWidth() - enemy1_image:getWidth()/2)
			newEnemy = {x = randomNumber, y = - enemy1_image:getHeight(), speed = vitesse_mechant1, img = enemy1_image}
		elseif enemyType == 2 then
			randomNumber = math.random(enemy2_image:getWidth()/2,love.graphics.getWidth() - enemy2_image:getWidth()/2)
			newEnemy = {x = randomNumber, y = - enemy2_image:getHeight(), speed = vitesse_mechant2, img = enemy2_image}
		elseif enemyType == 3 then
			randomNumber = math.random(enemy3_image:getWidth()/2,love.graphics.getWidth() - enemy3_image:getWidth()/2)
			newEnemy = {x = randomNumber, y = - enemy3_image:getHeight(), speed = vitesse_mechant3, img = enemy3_image}
		end
		
		table.insert(enemies,newEnemy)
	end

	for i,enemy in ipairs(enemies) do
		enemy.y = enemy.y + (enemy.speed * dt)

		if enemy.y > (love.graphics.getHeight() + enemy.img:getHeight()) then
			table.remove(enemies,i)
		end
	end

	for i, enemy in ipairs (enemies) do
		for j,bullet in ipairs(bullets) do
			if CheckCollision(enemy.x,enemy.y,enemy.img:getWidth(),enemy.img:getHeight(),bullet.x,bullet.y,bullet.img:getWidth(),bullet.img:getHeight()) then

				table.remove(bullets,j)
				table.remove(enemies,i)

				score = score + 1;
			end
		end

		if CheckCollision(enemy.x,enemy.y,enemy.img:getWidth(),enemy.img:getHeight(),player.x,player.y,player.img:getWidth(),player.img:getHeight())
		and isAlive then
			table.remove(enemies,i)
			isAlive = false
		end
	end
end

function StartScore()

	inGame = true
	inScore = true
end

function love.update(dt)

	if love.keyboard.isDown('escape') then
		love.event.push('Quit')
	end

	if not inGame then

		if love.keyboard.isDown('r') then
			
			StartGame()
		end

	elseif inGame then

		if not inScore then

			UpdateInGame(dt)

			if not isAlive then

				StartScore()
			end

		elseif inScore then

			if love.keyboard.isDown('r') then
			
				StartGame()
			end
		end
	end

	createCloudTimer = createCloudTimer - (1 * dt)
	if createCloudTimer < 0 then
		createCloudTimer = createCloudTimerMax

		randomNumber = math.random(- cloud_image:getWidth()/2,love.graphics.getWidth() + cloud_image:getWidth()/2)
		newCloud = {x = randomNumber, y = - cloud_image:getHeight(), img = cloud_image}
		table.insert(clouds,newCloud)
	end

	for i,cloud in ipairs(clouds) do
		cloud.y = cloud.y + (vitesse_nuage * dt)

		if cloud.y > (love.graphics.getHeight() + cloud_image:getHeight()) then
			table.remove(clouds,i)
		end
	end

	for i, background in ipairs (backgrounds) do
		background.y = background.y + (vitesse_ciel * dt)
		if background.y > (love.graphics.getHeight() - (background_image:getHeight() - love.graphics.getHeight())/2) then
			
			newBackground = {x = - (background_image:getWidth()/2) + (love.graphics.getWidth()/2), y = background.y - 3 * love.graphics.getHeight(), img = background_image}
			table.insert(backgrounds,newBackground)

			table.remove(backgrounds,i)
		end
	end
end

function love.draw(dt)

	for i, background in ipairs(backgrounds) do
		love.graphics.draw(background.img,background.x,background.y)
	end

	for i, cloud in ipairs(clouds) do
		love.graphics.draw(cloud.img,cloud.x,cloud.y)
	end

	if not inGame then

		love.graphics.draw(titre.img,titre.x,titre.y)
		love.graphics.draw(tutoriel.img,tutoriel.x,tutoriel.y)

	elseif inGame then

		if not inScore then

			love.graphics.draw(player.img,player.x,player.y)

			for i, bullet in ipairs(bullets) do
				love.graphics.draw(bullet.img,bullet.x,bullet.y)
			end

			for i,enemy in ipairs(enemies) do
				love.graphics.draw(enemy.img,enemy.x,enemy.y)
			end

		elseif inScore then

			love.graphics.draw(rejouer.img,rejouer.x,rejouer.y)

			love.graphics.print("Score: ",love.graphics:getWidth()/2 - 50,love.graphics:getHeight()/2 - 10)
			love.graphics.print(tostring(score),love.graphics:getWidth()/2 - 50,love.graphics:getHeight()/2 + 10)
		end
	end
end
