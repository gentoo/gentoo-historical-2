# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/portagemaster/portagemaster-0.2.0.ebuild,v 1.4 2002/11/25 22:27:08 karltk Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="A java portage browser and installer."
SRC_URI="http://portagemaster.sourceforge.net/packages/${P}.tar.bz2"
HOMEPAGE="http://portagemaster.sourceforge.net"
IUSE=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~sparc64"

DEPEND=">=dev-java/sun-jdk-1.4.0-r5
        >=dev-java/ant-1.4.1-r3
        >=dev-java/jikes-1.16"
RDEPEND=">=dev-java/sun-jdk-1.4.0-r5"

pkg_setup() {
	local foo
	foo=`java-config --java-version 2>&1 | grep "1.4."`
	if [ -z "$foo" ] ; then
		eerror "You have to set the 1.4.0 JDK as your system default to compile this package."
		enfo "Use java-config --set-system-vm=sun-jdk-1.4.0 (or more recent) to set it."
		exit 1
	fi
}

src_unpack() {
	unpack ${A}
}

src_compile() {
	ant
	cp src/portagemaster src/portagemaster.orig
	sed -e s:/usr/share/portagemaster/portagemaster.jar:/usr/share/portagemaster/lib/portagemaster-${PV}.jar: \
		< src/portagemaster.orig \
		> src/portagemaster || die
}

src_install() {
	dojar packages/portagemaster-${PV}.jar
	dobin src/portagemaster
}
