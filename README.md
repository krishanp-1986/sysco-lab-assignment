# StarWarsApi – Mobile Developer Test

[![develop](https://github.com/krishanp-1986/sysco-lab-assignment/actions/workflows/main.yml/badge.svg)](https://github.com/krishanp-1986/sysco-lab-assignment/actions/workflows/main.yml)

This project is the outcome of the **Sysco Labs Mobile Developer Test**.  
The task was to implement a mobile application that loads **Star Wars planets** and allows users to view planet details.

<table align="center">
  <tr>
    <td></td>
    <th align="center">List</th>
    <th align="center">Details</th>
    <th align="center">Search</th>
  </tr>

  <tr>
    <th align="center">🌙 Dark Mode</th>
    <td align="center">
      <img src="README Files/list-dark.png" height="300" width="150">
    </td>
    <td align="center">
      <img src="README Files/details-dark.png" height="300" width="150">
    </td>
    <td align="center">
      <img src="README Files/search-dark.png" height="300" width="150">
    </td>
  </tr>

  <tr>
    <th align="center">☀️ Light Mode</th>
    <td align="center">
      <img src="README Files/list-light.png" height="300" width="150">
    </td>
    <td align="center">
      <img src="README Files/details-light.png" height="300" width="150">
    </td>
    <td align="center">
      <img src="README Files/search-light.png" height="300" width="150">
    </td>
  </tr>
</table>


---

## Technical Description

Since this is a medium-sized application, it is implemented using the **MVVM** architecture with the reactive framework **RxSwift / RxCocoa**.

- **UITableViewDiffableDataSource** is used to manage data and provide cells efficiently.
- The app supports **offline and online** data fetching.
- **Realm** is used for local caching, with a cache validity of **5 minutes**.
- A lightweight **Mobile Design System** is implemented to demonstrate reusable UI components.
- The app supports both **Light and Dark Mode**, following system appearance settings.

---

## Testing

Unit tests are implemented using **Quick / Nimble**, following a **BDD-style** testing approach.

<p align="center">
  <img src="README Files/coverage.png">
</p>

---

## Continuous Integration

**Fastlane** is integrated with **GitHub Actions** to:
- Run unit tests
- Build the debug version of the app (without archiving)

<p align="center">
  <img src="README Files/git-actions.png">
</p>

---

## Requirements

- Xcode 15+
- iOS 16+
- CocoaPods

---

## Instructions

1. Clone the `develop` branch.
2. Run the following command to install dependencies:

```bash
pod install
