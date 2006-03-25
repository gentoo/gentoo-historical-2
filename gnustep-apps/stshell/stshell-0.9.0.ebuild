# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/stshell/stshell-0.9.0.ebuild,v 1.1 2006/03/25 22:48:02 grobian Exp $

inherit gnustep

DESCRIPTION="An interactive shell for StepTalk"
HOMEPAGE="http://www.gnustep.org/experience/StepTalk.html"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/libs/${P/stshell/StepTalk}.tar.gz"

KEYWORDS="~ppc ~x86"
LICENSE="LGPL-2.1"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}
	=gnustep-libs/steptalk-${PV}*"
RDEPEND="${GS_RDEPEND}
	=gnustep-libs/steptalk-${PV}*"
S="${WORKDIR}/${P/stshell/StepTalk}/Examples/Shell"

egnustep_install_domain "System"
