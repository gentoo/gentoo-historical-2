# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/kmms/kmms-0.7_beta6.ebuild,v 1.3 2002/05/27 17:27:38 drobbins Exp $

inherit kde-base || die

need-kde 2.2

S="${WORKDIR}/kmms-0.7beta6"
SRC_URI="mirror://sourceforge/kmms/kmms-0.7beta6.tar.gz"
HOMEPAGE="http://www.base2.de/"
DESCRIPTION="A KDE-Taskbar DockApplet control and title display for XMMS." 

