# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/net-sftp/net-sftp-0.08.ebuild,v 1.7 2006/03/31 20:27:17 mcummings Exp $

inherit perl-module

MY_P=Net-SFTP-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Secure File Transfer Protocol client"
HOMEPAGE="http://search.cpan.org/search?module=${PN}"
SRC_URI="mirror://cpan/authors/id/D/DR/DROLSKY/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha ~mips ~ppc ~sparc x86"
IUSE=""

DEPEND=">=dev-perl/net-ssh-perl-1.25"
