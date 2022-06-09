import {useState, useEffect} from 'react'
const getOrientation = () => {
  let orientation = window.screen.orientation?.type ;
  if (!orientation) {
    var mql = window.matchMedia("(orientation: portrait)");
    return mql.matches ? 'portrait' : 'landscape' ;
  }
  switch (orientation) {
    case 'landscape-primary':
    case 'landscape-secondary': 
      return'landscape';
    default:
      return 'portrait'
  }
}

const useScreenOrientation = () => {
  const [orientation, setOrientation] =
    useState(getOrientation())

  const updateOrientation = (event:Event) => {
    setOrientation(getOrientation())
  }

  useEffect(() => {
    window.addEventListener(
      'orientationchange',
      updateOrientation
    )
    return () => {
      window.removeEventListener(
        'orientationchange',
        updateOrientation
      )
    }
  }, [])

  return orientation
}

export default useScreenOrientation