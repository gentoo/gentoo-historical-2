# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/ikvm/ikvm-0.8.0.0.ebuild,v 1.3 2005/01/01 17:48:21 eradicator Exp $

inherit mono

DESCRIPTION="Java VM for .NET"
HOMEPAGE="http://www.ikvm.net/"

SRC_URI="http://www.go-mono.com/archive/1.0/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"

KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND=">=dev-dotnet/mono-1.0"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}

	# Fix some makefile borkage.
	sed -i -e 's:-e$:-e \\:' ${S}/scripts/Makefile.in
}

src_compile() {
	econf || die
}

src_install() {
	make DESTDIR=${D} install || die
}
