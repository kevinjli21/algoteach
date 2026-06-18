'use client';

import { Allotment } from 'allotment';
import 'allotment/dist/style.css';
import type { ReactNode } from 'react';

type Props = {
  leftPane: ReactNode;
  rightPane: ReactNode;
};

export default function AllotmentLayout({ leftPane, rightPane }: Props) {
  return (
    <Allotment>
      <Allotment.Pane minSize={300} preferredSize="50%">
        {leftPane}
      </Allotment.Pane>
      <Allotment.Pane minSize={380} preferredSize="50%">
        {rightPane}
      </Allotment.Pane>
    </Allotment>
  );
}
