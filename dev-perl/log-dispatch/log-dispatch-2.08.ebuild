# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/log-dispatch/log-dispatch-2.08.ebuild,v 1.4 2004/06/25 00:44:04 agriffis Exp $

inherit perl-module

MY_P=Log-Dispatch-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Dispatches messages to multiple Log::Dispatch::* objects"
SRC_URI="http://www.cpan.org/authors/id/D/DR/DROLSKY/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/authors/id/D/DR/DROLSKY/"
SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ~amd64 ~ppc ~sparc alpha"

DEPEND="${DEPEND}
		dev-perl/module-build
		dev-perl/Params-Validate"
style="builder"
