# Matrimony SwiftUI App

## ZIP FILE LINK
[.Zip File](https://github.com/Vivek09Chahal/MatramonyApp/blob/main/Matramony.zip)

A beautiful and modern matrimony app built with SwiftUI, featuring profile management, discovery, and matching functionality.

## Features Completed ✅

### Authentication & Onboarding
- **Beautiful Sign-In View**: Gradient backgrounds, custom form styling, and smooth animations
- **Comprehensive Sign-Up Flow**: Complete profile creation with photo picker integration
- **Enhanced Authentication Logic**: Proper validation, error handling, and user session management

### Profile Management
- **Detailed Profile View**: Sectioned layout with gradient backgrounds and beautiful information display
- **Advanced Profile Editor**: Custom text fields, photo picker, age/gender selectors, and aesthetic UI
- **Profile Data Model**: Complete user model with SwiftData integration for persistence

### Discovery & Matching
- **Interactive Discover View**: Card-based swiping interface with sample profiles
- **Swipe Gestures**: Like, pass, and super-like functionality with animations
- **Card Stack Animation**: Multiple cards with depth and interactive gestures

### Likes & Matches
- **Tabbed Likes Interface**: "Your Likes", "Who Liked You", and "Matches" sections
- **Match Indicators**: Visual indicators for successful matches
- **Interactive Cards**: Like/pass buttons and chat initiation for matches

### UI/UX Enhancements
- **Consistent Design Language**: Pink/purple gradient theme throughout the app
- **Custom Components**: Reusable UI elements like CustomTextField and ProfileSection
- **Modern Aesthetics**: Shadows, rounded corners, and smooth animations
- **Responsive Layout**: Proper spacing and visual hierarchy

## Tech Stack

- **SwiftUI**: Modern declarative UI framework
- **SwiftData**: Core Data replacement for data persistence
- **PhotosUI**: Native photo picker integration
- **iOS 18.5+**: Latest iOS features and APIs

## Project Structure

```
Matramony/
├── Authentication/
│   ├── SignIn/View/signInView.swift
│   ├── SignUp/View/signUpView.swift
│   └── ViewModel/authViewModel.swift
├── profile/
│   ├── View/
│   │   ├── profileView.swift
│   │   ├── profileEditView.swift
│   │   └── customViewBuilder.swift
│   ├── ViewModel/profileViewModel.swift
│   └── Model/profilemodel.swift
├── discoverView.swift
├── likesView.swift
├── tabView.swift
└── MatramonyApp.swift
```

## Key Components

### Custom UI Elements
- `CustomTextField`: Stylized input fields with icons
- `ProfileSection`: Reusable sectioned content containers
- `ProfileCard`: Interactive swipeable profile cards
- `LikeCard`, `MatchCard`: Specialized cards for different contexts

### Data Models
- `User`: Complete user profile with SwiftData integration
- `Gender`: Enumeration for gender selection
- `SampleProfile`: Demo data structure for discovery

### ViewModels
- `authViewModel`: Handles authentication, validation, and user sessions
- `profileViewModel`: Manages profile CRUD operations with SwiftData

## Current Functionality

1. **App Launch**: Beautiful sign-in screen with gradient background
2. **User Registration**: Complete profile creation flow
3. **Profile Management**: View and edit user profiles with photo upload
4. **Discovery**: Swipe through potential matches with interactive cards
5. **Likes System**: Track likes, matches, and initiate conversations
6. **Navigation**: Seamless tab-based navigation between features

## Next Steps (Pending Implementation)

### Core Features to Add
- [ ] Real-time messaging system for matches
- [ ] Advanced filtering and search preferences
- [ ] Photo gallery support (multiple photos per profile)
- [ ] Location-based matching
- [ ] Push notifications for new likes/matches

### Technical Improvements 
- [ ] Backend integration (Firebase/custom API)
- [ ] Real user authentication (not simulated)
- [ ] Image storage and optimization
- [ ] Offline data synchronization
- [ ] Unit and UI testing

### Additional Features 
- [ ] Settings and account management
- [ ] Privacy controls and blocking
- [ ] Profile verification system
- [ ] Advanced matchmaking algorithms
- [ ] Video chat integration

## Build Instructions

1. Open `Matramony.xcodeproj` in Xcode
2. Select iOS Simulator or connected device
3. Build and run the project (⌘+R)

## Design Philosophy

The app follows modern iOS design principles with:
- Consistent pink/purple gradient theme
- Clean, minimalist interface
- Intuitive navigation patterns
- Accessibility considerations
- Responsive design for different screen sizes

## Screenshots

*Add screenshots of key screens here when available*

---

**Status**: ✅ Core functionality complete and ready for testing
**Last Updated**: December 2024
