import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import { translationsFr } from './translation/fr'
import { translationsEn } from './translation/en'

const lang = localStorage.getItem("lang") || 'en';

type MissingKeyHandler = (
  lngs: readonly string[],
  ns: string,
  key: string,
  fallbackValue: string,
  updateMissing: boolean,
  options: any,
) => void

const missingKeyHandler: MissingKeyHandler = (lngs, ns, key, fallbackValue, updateMissing, options) => {
  if (lngs.length ===1 && lngs[0] === 'fr') {
    return
  }
  console.log('Missing translation', key);
};

i18n
  .use(initReactI18next)
  .init({
    lng: lang,
    resources: {
      en: { translation: translationsEn },
      fr: { translation: translationsFr },
    },
    fallbackLng: false,
    saveMissing: true,
    missingKeyHandler: missingKeyHandler
});

export default i18n;