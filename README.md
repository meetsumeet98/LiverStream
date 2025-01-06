# LiverStream: Reels Playback and Commenting UI

<img width="350" alt="LIVEr-stream-app-UI" src="https://github.com/user-attachments/assets/68461325-d887-4374-8f5e-2f37c0be3ac0" />

## Project Overview  
This project demonstrates a custom-built full-screen video player for iOS, designed using **Swift**, **UIKit**, **AVFoundation**, **UICollectionView**, and **UITableView**. The app focuses on providing a seamless user experience with smooth animations, quality UI, and a well-structured codebase.  

## Technologies Used  
- **Swift**  
- **UIKit**  
- **AVFoundation**  
- **UICollectionView**  
- **UITableView**  
- **Lottie** (for animations)  
- **AutoLayout**  

## Features  

### Core Functionality  
1. **Full-Screen Video Playback**  
   - Each `UICollectionViewCell` contains a full-screen video player.  
   - Videos automatically play and loop when loaded.  
   - Only one video is visible and playing at a time, ensuring a focused user experience.  

2. **User Information Display**  
   - Displays **username**, **profile picture**, **viewers**, and **likes** overlaid on the video.  
   - Top section UI is built using **XIBs** for flexibility and reusability.  

3. **Smooth Swiping**  
   - Users can swipe up or down to transition between videos.  
   - The swipe interaction ensures a full-screen display for each cell with smooth animations.  

4. **Mock Comments Section**  
   - Transparent `UITableView` displaying mock comments that scroll into view every **2 seconds**.  
   - Each comment displays the **username** (in gray text), **profile picture**, and **comment** (in white text).  
   - The comments section has a transparent background, maintaining focus on the video.  

5. **Interactive Comment Input**  
   - Tapping on the comment text field brings up the keyboard.  
   - The entire UI shifts up smoothly to accommodate the keyboard.  
   - New comments are added to the scroll view with animations, pushing older comments upward.  
 
6. **Gradient Mask for Top Comment**  
   - The topmost comment has a **fade-to-transparent gradient mask**, adding a polished visual effect.  

7. **Floating Heart Animation**  
   - Double-tap on the video player to trigger a **floating heart animation**.  
   - Used **Lottie** for easy animation implementation, but it can also be achieved with **CoreAnimation**.  

9. **Pause/Play Functionality**  
   - Single-tap on the video pauses or resumes playback.  

## Technical Details  

### UI Construction  
- **Top Section**: Built using **XIBs** to ensure modularity and reusability.  
- **Bottom Section**: Built programmatically for dynamic control over layout and animations.  
- **Autolayout**: The entire app leverages **Storyboard** and **AutoLayout** for a responsive UI design.  

### Core Components  
- **UICollectionView**: To handle full-screen swiping between videos.  
- **UITableView**: For displaying comments with a transparent background.  
- **AVFoundation**: To handle video playback, looping, and related media functionalities.  

---

## How to Run the Project  
1. Clone the repository.  
2. Open the project in **Xcode**.  
3. Build and run on an iOS simulator or physical device.  
4. Enjoy the full-screen video experience with interactive comments and animations!  


---

## License  
This project is licensed under the [MIT License](LICENSE).  

Feel free to explore, suggest improvements, or fork the repository! 😊  
