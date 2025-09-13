-- Пользователи LMS

CREATE TABLE users(
    id INT PRIMARY KEY AUTO_INCREMENT,
    login VARCHAR(20) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- пароли хранятся в зашифрованном виде
    salt VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Все уроки разделены на разделы. Можно изменять order_index для изменения порядка отображения в меню
CREATE TABLE sections(
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    order_index INT NOT NULL
);

-- Непосредственно уроки
CREATE TABLE lessons(
    id INT PRIMARY KEY AUTO_INCREMENT,
    section_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    order_index INT NOT NULL,
    FOREIGN KEY(section_id) REFERENCES sections(id)
);

-- каждый урок состоит из степов. В зависимости от категории степа меняется его отображение в я LMS
CREATE TABLE steps_category(
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(30) NOT NULL
);

-- и сами степы
CREATE TABLE steps(
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT NOT NULL,
    lesson_id INT NOT NULL,
    order_index INT NOT NULL,
    html TEXT NOT NULL,                                         -- html-содержимое степа
    correct_answer TEXT NOT NULL,                               -- эталонный ответ. Проверяющая система сравнивает ответ пользователя с эталоном
    FOREIGN KEY (category_id) REFERENCES steps_category(id),
    FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);



-- решения пользователей сохраняются в таблицу solutions
CREATE TABLE solutions(
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    step_id INT NOT NULL,
    last_attempt_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- время последней попытки решения
    attempts_count INT DEFAULT 0,                                                      -- количество попыток
    last_answer TEXT,                                                                  -- последний ответ пользователя. История ответов не хранится, только последний ответ
    is_correct BOOLEAN DEFAULT FALSE,                                                  -- пометка, правильный ли ответ
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (step_id) REFERENCES steps(id),
    UNIQUE KEY (user_id, step_id)
);




-- таблица с просмотрами степов. Просто отметка о том, что конкретный пользователь уже посмотрел этот степ 
-- (подсветится зеленым в верхнем меню со степами)
CREATE TABLE step_views (
    id INT PRIMARY KEY AUTO_INCREMENT,
    step_id INT NOT NULL,
    user_id INT NOT NULL,
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (step_id) REFERENCES steps(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE KEY unique_user_step_view (user_id, step_id)
);



