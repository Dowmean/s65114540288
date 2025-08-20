const getConnection = require('../config/database');

const checkRoleOrOwnership = async (req, res, next) => {
  const { id } = req.params;
  const userEmail = req.body.email || req.query.email;

  if (!id || !userEmail) {
    return res.status(400).json({ message: 'Post ID and Email are required' });
  }

  try {
    const client = await getConnection();
    const { rows } = await client.query(
      `SELECT p.email AS ownerEmail, u.role
       FROM product p
       JOIN users u ON p.email = u.email
       WHERE p.id = $1`,
      [id]
    );

    if (rows.length === 0) {
      await client.end();
      return res.status(404).json({ message: 'Post not found' });
    }

    const post = rows[0];

    if (post.ownerEmail === userEmail || post.role === 'Admin') {
      next();
    } else {
      res.status(403).json({ message: 'Permission denied' });
    }

    await client.end();
  } catch (error) {
    console.error('Error in Middleware:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
};

module.exports = checkRoleOrOwnership;
