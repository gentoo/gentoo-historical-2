# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/java-access-bridge/java-access-bridge-1.6.0-r2.ebuild,v 1.2 2011/08/19 11:32:00 nirbheek Exp $

EAPI="2"
inherit java-pkg-2 gnome2 autotools

DESCRIPTION="Gnome Java Accessibility Bridge"
HOMEPAGE="http://developer.gnome.org/projects/gap/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

COMMON_DEPEND=">=gnome-base/libbonobo-2
	>=gnome-extra/at-spi-1.7.10:1"

RDEPEND="$COMMON_DEPEND
	>=virtual/jre-1.4"

DEPEND="$COMMON_DEPEND
	>=virtual/jdk-1.4
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	java-pkg-2_src_prepare
	epatch "${FILESDIR}"/${P}-missingclasses.patch
	eautoreconf
}

pkg_setup() {
	java-pkg-2_pkg_setup
	G2CONF="--with-java-home=${JDK_HOME}"
}

src_configure() {
	gnome2_src_configure
}

src_compile() {
	emake JAVAC="${JAVAC} ${JAVACFLAGS}" || die "compile failure"
}

src_install() {
	gnome2_src_install

	java-pkg_dojar "${D}"/usr/share/jar/*.jar

	insinto /usr/share/${PN}
	doins "${D}"/usr/share/jar/*.properties

	rm -rf "${D}"/usr/share/jar
}

pkg_preinst() {
	java-pkg-2_pkg_preinst
	gnome2_pkg_preinst
}

pkg_postinst() {
	elog
	elog "The Java Accessibility Bridge for GNOME has been installed."
	elog
	elog "To enable accessibility support with your java applications, you"
	elog "have to enable CORBA traffic over IP. To do this, you may add the"
	elog "following line to your /etc/orbitrc or ~/.orbitrc file:"
	elog
	elog "  ORBIIOPIPv4=1"
	elog
}
