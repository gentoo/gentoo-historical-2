# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-config/java-config-2.0.28-r1.ebuild,v 1.3 2006/09/14 19:57:08 caster Exp $

inherit base distutils eutils

DESCRIPTION="Java environment configuration tool"
HOMEPAGE="http://www.gentoo.org/proj/en/java/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

# 2.4 needed to fix bug #147594, offending code fixed in trunk, so next bump can drop this
DEPEND=">=dev-lang/python-2.4"
RDEPEND=">=dev-lang/python-2.4
	dev-java/java-config-wrapper"

PATCHES="${FILESDIR}/${P}-classpath.patch"

src_install() {
	distutils_src_install

	insinto /usr/share/java-config-2/config/
	for i in alpha amd64 hppa ia64 ppc ppc64 sparc x86; do
		if use ${i}; then
			newins config/jdk-defaults-${i}.conf jdk-defaults.conf || die "arch	config not found"
		fi
	done

	for tool in $(< config/symlink-tools); do
		dosym /usr/bin/run-java-tool /usr/bin/${tool}
	done

	# Install profile.d for setting JAVA_HOME
	dodir /etc/profile.d
	exeinto /etc/profile.d
	newexe ${FILESDIR}/${PN}-${SLOT}.profiled ${PN}-${SLOT}.sh || die "newexe failed"
}


pkg_postrm() {
	python_mod_cleanup /usr/share/java-config-2/pym/java_config
}

pkg_postinst() {
	python_mod_optimize /usr/share/java-config-2/pym/java_config

	einfo "The way Java is handled on Gentoo has been recently updated."
	einfo "If you have not done so already, you should follow the"
	einfo "instructions available at:"
	einfo "\thttp://www.gentoo.org/proj/en/java/java-upgrade.xml"
	echo
	einfo "While we moving towards the new Java system, we require"
	einfo "a 1.3 or 1.4 JDK to be installed to ensure backwards compatibility"
	einfo "with the old system."
	einfo "For more details about this, please see:"
	einfo "\thttps://overlays.gentoo.org/proj/java/wiki/Why_We_Need_Java14"
}
