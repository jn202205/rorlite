CREATE TABLE cats (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE statuses (
  id INTEGER PRIMARY KEY,
  text VARCHAR(255) NOT NULL,
  cat_id INTEGER,

  FOREIGN KEY(cat_id) REFERENCES cat(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "26th and Guerrero"),
  (2, "Dolores and Market"),
  (3, "Sutter and Hyde");

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Devon", "Watts", 1),
  (2, "Matt", "Rubens", 1),
  (3, "Ned", "Ruggeri", 2),
  (4, "Catless", "Human", NULL),
  (5, "Jon", "Newman", 3);

INSERT INTO
  cats (id, name, owner_id)
VALUES
  (1, "Breakfast", 1),
  (2, "Earl", 2),
  (3, "Haskell", 3),
  (4, "Markov", 3),
  (5, "Stray Cat", NULL);

INSERT INTO
  statuses (id, cat_id, text)
VALUES
  (1, 1, "Breakfast loves string!" ),
  (2, 2, "Earl is mighty!" ),
  (3, 1, "Breakfast is cool!" );
