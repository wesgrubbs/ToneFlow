# Dynamic Audio Explorer

Dynamic Audio Explorer is an interactive Swift project developed for my **Music Level 2 class final project**. This application is an explorative space for sound generation, utilizing the powerful capabilities of Swift's `AVAudioEngine`. It allows users to dynamically manipulate sound frequency, amplitude, and waveform type through intuitive gestures and a user-friendly interface. The project serves as an experimental platform to delve into real-time audio synthesis and control using Swift.

## Features

- **Interactive Audio Synthesis**:  
  Users can generate audio dynamically by dragging their finger across the screen. The x-coordinate controls frequency, and the y-coordinate adjusts amplitude.

- **Waveform Customization**:  
  A built-in toolbar allows toggling between different waveform types, including:
  - Sine Wave
  - Square Wave
  - Triangle Wave
  - Sawtooth Wave

- **Real-Time Visualization**:  
  Visual crosshairs track user interaction, displaying the precise touch point and its associated coordinates.

- **SwiftUI Integration**:  
  A modern, declarative UI built with SwiftUI, offering smooth interactions and seamless integration with the `AVAudioEngine`.

## How It Works

1. **Gesture-Based Audio Control**:  
   The app uses drag gestures to control audio parameters:
   - The **x-axis** of the touch point determines the frequency.
   - The **y-axis** sets the amplitude (volume).

2. **Waveform Switching**:  
   Users can toggle between waveform types using a toolbar at the bottom of the screen. Each waveform offers a unique sound signature, allowing users to explore different audio textures.

3. **AVAudioEngine Power**:  
   The project leverages `AVAudioEngine` and `AVAudioSourceNode` to generate real-time audio based on user input.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/DynamicAudioExplorer.git
   cd DynamicAudioExplorer
   ```

2. Open the project in Xcode:
   ```bash
   open DynamicAudioExplorer.xcodeproj
   ```

3. Build and run the project:
   - Ensure you have a physical iOS device or simulator running iOS 16.0 or higher.
   - Hit the **Run** button in Xcode to launch the app.

## Usage

1. Launch the app on your iOS device.
2. Drag your finger across the screen:
   - Move **horizontally** to adjust the frequency.
   - Move **vertically** to control the amplitude.
3. Use the toolbar at the bottom to toggle between different waveforms.
4. Listen and explore how the sound changes dynamically as you interact with the app!

## Screenshots

### Main Interface
| **Drag Gesture Crosshairs** | **Waveform Selection** |
|-----------------------------|-------------------------|
| ![Crosshairs Screenshot](screenshots/crosshairs.png) | ![Waveform Picker Screenshot](screenshots/waveform-picker.png) |

> *Screenshots illustrate the app's crosshair tracking and waveform selection functionality.*

## Technology Stack

- **Swift**
- **SwiftUI**
- **AVAudioEngine**
- **AVAudioSourceNode**

## Educational Context

This project was developed as a **final project for Music Level 2 class**, aiming to explore the creative possibilities of real-time audio synthesis using Swift. It serves as a foundation for understanding digital audio, waveforms, and user interaction with sound.

## Future Improvements

- Add support for custom waveform shapes using mathematical functions.
- Implement a spectrogram or visual audio analyzer.
- Allow saving and exporting custom sound creations.
- Expand the frequency and amplitude range for further experimentation.

## License

This project is open source and available under the [MIT License](LICENSE).

## Contributing

Contributions are welcome! If you have ideas for new features, improvements, or bug fixes, feel free to submit a pull request.

---

Happy exploring, and enjoy creating dynamic audio landscapes! 🎶

### Author

- **Wesley Grubbs**  
  [GitHub Profile](https://github.com/wesgrubbs)  
  *Music Level 2 Student & Creative Technologist*
