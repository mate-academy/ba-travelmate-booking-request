import { useState } from 'react'
import { Globe, Heart, ArrowRight, Search, MapPin, Calendar, Star } from 'lucide-react'
import './App.css'

function App() {
  const [showAuth, setShowAuth] = useState(false)

  const handleAuthClick = (e) => {
    e.preventDefault()
    setShowAuth(true)
  }

  if (showAuth) {
    return (
      <div className="auth-screen">
        <button className="back-btn" onClick={() => setShowAuth(false)}>Back</button>
        <h1>TO BE DONE</h1>
      </div>
    )
  }

  return (
    <div className="app-container">
      {/* Header */}
      <header className="header">
        <div className="logo">
          <img src="/logo.png" alt="TravelMate Logo" className="logo-image" />
        </div>
        
        <nav className="nav-links">
          <a href="#" className="nav-link">Destinations</a>
          <a href="#" className="nav-link">Magazine</a>
          <a href="#" className="nav-link">About</a>
        </nav>
        
        <div className="auth-actions">
          <a href="#" className="login-link" onClick={handleAuthClick}>Log in</a>
          <button className="signup-btn" onClick={handleAuthClick}>Sign up</button>
        </div>
      </header>

      {/* Main Content */}
      <main className="main-content">
        {/* Left Column */}
        <div className="left-column">
          <div className="badge">The smart way to travel</div>
          <h1 className="hero-title">
            Find and book<br />
            the perfect hotel<br />
            in minutes
          </h1>
          <p className="hero-subtitle">
            Compare prices, ratings, and booking conditions from multiple<br />
            platforms in one place — without opening dozens of tabs.
          </p>
          <button className="cta-btn">
            Find a hotel <ArrowRight size={18} />
          </button>
          
          <div className="social-proof">
            <div className="avatars">
              <div className="avatar">👤</div>
              <div className="avatar">👤</div>
              <div className="avatar">👤</div>
              <div className="avatar">👤</div>
            </div>
            <div className="proof-text">
              <div className="stars">
                {[...Array(5)].map((_, i) => (
                  <Star key={i} size={14} fill="#FACC15" color="#FACC15" />
                ))}
              </div>
              <p><strong>More than 10,000 travelers</strong> already find accommodation faster with our service</p>
            </div>
          </div>
        </div>

        {/* Right Column */}
        <div className="right-column">
          <div className="image-card">
            <img src="/hotel.png" alt="Luxury Hotel" className="hotel-image" />
            
            <button className="like-btn">
              <Heart size={20} color="#71717A" />
            </button>
            
            <div className="price-guarantee">
              <Globe size={14} color="#C25100" /> Best Price Guarantee
            </div>
          </div>
          
          <div className="card-details">
            <h3 className="hotel-name">The Grand Budapest</h3>
            <div className="rating-badge">
              <Star size={12} fill="#FACC15" color="#FACC15" /> 4.9
            </div>
          </div>

          {/* Search Widget Component */}
          <div className="search-widget">
            <div className="widget-item">
              <Search className="widget-icon" size={18} color="#C25100" />
              <span className="widget-text">Quick Search</span>
            </div>
            <div className="widget-divider"></div>
            <div className="widget-item">
              <MapPin className="widget-icon" size={18} color="#C25100" />
              <span className="widget-text">Paris, France</span>
            </div>
            <div className="widget-divider"></div>
            <div className="widget-item">
              <Calendar className="widget-icon" size={18} color="#C25100" />
              <span className="widget-text">Oct 12 - Oct 16</span>
            </div>
            <button className="search-deals-btn">Search Deals</button>
          </div>
          
          <button className="view-deal-btn">View Deal</button>
        </div>
      </main>
    </div>
  )
}

export default App
