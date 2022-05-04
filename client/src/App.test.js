import React from 'react';
import { render } from '@testing-library/react';
import App from './App';

test('renders Sign in text and button', () => {
  const { getByRole } = render(<App />);

  const h1Element = getByRole('heading', {name: 'Sign in'});
  expect(h1Element).toBeInTheDocument();

  const signInButton = getByRole('button', {name: 'Sign In'});
  expect(signInButton).toBeInTheDocument();
});
