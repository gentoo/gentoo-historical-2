# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/slashtime/slashtime-0.5.6.ebuild,v 1.1 2008/08/18 02:16:05 ken69267 Exp $

EAPI=1
JAVA_PKG_IUSE="source"

inherit java-pkg-2

DESCRIPTION="View the time at locations around the world"
HOMEPAGE="http://research.operationaldynamics.com/projects/slashtime/"
SRC_URI="http://research.operationaldynamics.com/projects/${PN}/dist/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP=">=dev-java/java-gnome-4.0.8:4.0"

DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

src_compile() {
	# Handwritten in perl so not using econf
	./configure --prefix=/usr || die

	emake || die "emake failed."
}

src_install() {
	#this is needed to generate the slashtime jar
	emake DESTDIR="${D}" install || die "emake install failed."

	#remove incorrect install path
	rm -r "${D}"/usr/share/java/
	rm "${D}"/usr/bin/slashtime

	java-pkg_register-dependency java-gnome-4.0 gtk-4.0.jar
	java-pkg_dojar tmp/${PN}.jar
	java-pkg_dolauncher ${PN} --main slashtime.client.Master \
		--pwd /usr

	dodoc AUTHORS HACKING PLACES README TODO || die "dodoc failed."

	use source && java-pkg_dosrc src/java/slashtime
}
