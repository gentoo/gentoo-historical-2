# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Authen-NTLM/Authen-NTLM-1.02.ebuild,v 1.6 2005/01/13 02:13:31 gustavoz Exp $

inherit perl-module

S=${WORKDIR}/NTLM-${PV}
DESCRIPTION="An NTLM authentication module"
SRC_URI="http://cpan.org/modules/by-module/Authen/NTLM-${PV}.tar.gz"
HOMEPAGE="http://cpan.org/modules/by-module/Authen/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~x86 ~amd64 ~ppc sparc ~alpha"
IUSE=""

DEPEND="${DEPEND}"
RDEPEND=">=dev-perl/MIME-Base64-3.00"

export OPTIMIZE="$CFLAGS"
