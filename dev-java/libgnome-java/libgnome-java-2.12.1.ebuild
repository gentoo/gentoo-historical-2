# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/libgnome-java/libgnome-java-2.12.1.ebuild,v 1.6 2006/09/14 20:20:26 nichoj Exp $

# Must be before the gnome.org inherit
GNOME_TARBALL_SUFFIX="gz"
inherit java-pkg eutils gnome.org

DESCRIPTION="Java bindings for GNOME"
HOMEPAGE="http://java-gnome.sourceforge.net/"

# Not on gnome.org mirrors yet :-(
SRC_URI="http://research.operationaldynamics.com/linux/java-gnome/dist/${PF}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="2.12"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc gcj"

DEPS=">=gnome-base/libgnome-2.10.0
	>=gnome-base/libgnomeui-2.12.0
	>=gnome-base/libgnomecanvas-2.12.0
	>=dev-java/glib-java-0.2.1
	>=dev-java/libgtk-java-2.8.1"
DEPEND=">=virtual/jdk-1.4
	${DEPS}"
RDEPEND=">=virtual/jre-1.4
	${DEPS}"

pkg_setup() {
	java-pkg_pkg_setup
	if use gcj ; then
		if ! built_with_use sys-devel/gcc gcj ; then
			ewarn
			ewarn "You must build gcc with the gcj support to build with gcj"
			ewarn
			ebeep 5
			die "No GCJ support found!"
		fi
	fi
}

src_compile() {
	# JARDIR is a hack for java-config
	econf $(use_with gcj gcj-compile) \
		$(use_with doc javadocs) \
		--with-jardir=/usr/share/${PN}-${SLOT}/lib \
		|| die "configure failed"

	emake || die "compile failed"

	# Fix the broken pkgconfig file
	sed -i \
		-e "s:classpath.*$:classpath=\${prefix}/share/${PN}-${SLOT}/lib/${PF}.jar:" \
		${S}/gnome2-java.pc
}

src_install() {
	emake DESTDIR=${D} install || die "install failed"

	# Examples and tutorial as documentation
	use doc || rm -rf ${D}/usr/share/doc/${PF}/{examples,tutorial}

	# use java-pkg_dojar to install the jar
	rm -rf ${D}/usr/share/${PN}-${SLOT}

	mv ${S}/gnome${SLOT}.jar ${S}/${PF}.jar
	java-pkg_dojar ${S}/${PF}.jar

	if use doc ; then
		java-pkg_dohtml -r ${S}/doc
	fi
}
