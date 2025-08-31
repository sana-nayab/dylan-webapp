import React from 'react';

const Header: React.FC = () => {
  const errorData = {
    code: 'rate-limited',
    message: 'You have hit the rate limit. Please upgrade to keep chatting.',
    providerLimitHit: false,
    isRetryable: true,
  };

  return (
    <header className="p-4 bg-red-600 text-white">
      <h1 className="text-lg font-bold">Error</h1>
      <pre className="mt-2 text-sm bg-red-800 p-2 rounded">
        {JSON.stringify(errorData, null, 2)}
      </pre>
    </header>
  );
};

export default Header;
