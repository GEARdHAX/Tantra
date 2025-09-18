// Function to play text-to-speech using browser's Web Speech API
export const speakText = (text, language = 'en-US') => {
    if ('speechSynthesis' in window) {
        const speech = new SpeechSynthesisUtterance();
        speech.text = text;
        speech.lang = language;
        speech.volume = 1;
        speech.rate = 1;
        speech.pitch = 1;
        window.speechSynthesis.speak(speech);
        return true;
    } else {
        console.error('Text-to-speech not supported in this browser');
        return false;
    }
};

// Function to play pre-recorded audio alert
export const playAudioAlert = (alertType) => {
    const alertSounds = {
        moisture: '/audio/moisture_alert.mp3',
        temperature: '/audio/temperature_alert.mp3',
        general: '/audio/general_alert.mp3'
    };

    const sound = new Audio(alertSounds[alertType] || alertSounds.general);
    sound.play().catch(error => {
        console.error('Failed to play audio alert:', error);
    });
};

// Mock function to simulate API call for cloud text-to-speech
export const getCloudTTS = async (text, language = 'en-US') => {
    // In a real implementation, this would call Google Cloud TTS or similar
    console.log(`TTS API call would happen here with text: "${text}" in language: ${language}`);
    // For demo purposes, we'll use the browser's built-in TTS
    return speakText(text, language);
};