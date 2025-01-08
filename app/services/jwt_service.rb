class JwtService
  # Encode the user ID into a JWT token
  def self.encode(payload)
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end

  # Decode a JWT token and retrieve the payload
  def self.decode(token)
    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
      Rails.logger.debug("Decoded Token: #{decoded}")
      decoded.first  # Return only the payload (first element of the decoded array)
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT Decode Error: #{e.message}")
      nil  # Return nil if token is invalid
    end
  end
end
