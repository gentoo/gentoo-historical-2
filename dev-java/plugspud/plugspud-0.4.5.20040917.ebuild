# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/plugspud/plugspud-0.4.5.20040917.ebuild,v 1.1 2004/09/17 09:28:58 axxo Exp $

inherit java-pkg

DESCRIPTION="plugspud is something Gruntspud needs."
HOMEPAGE="http://gruntspud.sourceforge.net/"
SRC_URI="mirror://gentoo/plugspud-gentoo-cvs-20040917.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE="jikes"
DEPEND=">=virtual/jdk-1.3
		dev-java/ant
		jikes? ( dev-java/jikes )"
RDEPEND=">=virtual/jre-1.3"

S=${WORKDIR}/plugspud

src_compile() {
	local antflags=""
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"
	ant dist ${antflags} || die "compilation failed"
}

src_install() {
	java-pkg_dojar dist/lib/plugspud.jar
}
