# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/net-sftp/net-sftp-0.05.ebuild,v 1.5 2004/07/14 19:48:03 agriffis Exp $

inherit perl-module

MY_P=Net-SFTP-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Secure File Transfer Protocol client"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/B/BT/BTROTT/${MY_P}.readme"
SRC_URI="http://www.cpan.org/modules/by-authors/id/B/BT/BTROTT/${MY_P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~mips ~alpha"
IUSE=""

DEPEND="dev-perl/net-ssh-perl"
