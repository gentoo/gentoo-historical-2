# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gjdoc/gjdoc-0.7.7.ebuild,v 1.2 2005/12/28 20:48:44 betelgeuse Exp $

inherit java-pkg

DESCRIPTION="A javadoc compatible Java source documentation generator."
HOMEPAGE="http://www.gnu.org/software/cp-tools/"
SRC_URI="ftp://ftp.gnu.org/gnu/classpath/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

# Possible USE flags.
#
# native: to --enable-native
# doc:    to generate javadoc
# debug:  There is a debug doclet installed by default but maybe could
#         have a wrapper that uses it.
#
IUSE="xmldoclet source"

# Refused to emerge with sun-jdk-1.3* complaining about wanting a bigger stack size
DEPEND=">=dev-java/antlr-2.7.1
		>=virtual/jdk-1.4
		source? ( app-arch/zip )"

RDEPEND=">=virtual/jre-1.4
		>=dev-java/antlr-2.7.1"

src_compile() {
	# I think that configure will do --enable-native if it finds gcj
	# so we'll disable it explicitly
	local myc="--with-antlr-jar=$(java-pkg_getjar antlr antlr.jar) --disable-native"
	myc="${myc} --disable-dependency-tracking"

	econf ${myc} \
		$(use_enable xmldoclet) || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	local jars="com-sun-tools-doclets-Taglet gnu-classpath-tools-gjdoc com-sun-javadoc"
	for jar in ${jars}; do
		java-pkg_newjar ${jar}-${PV}.jar ${jar}.jar
	done

	dobin ${FILESDIR}/gjdoc
	dodoc AUTHORS ChangeLog NEWS README

	cd ${S}/docs
	make DESTDIR=${D} install || die "Failed to install documentation"

	use source && java-pkg_dosrc "${S}/src"/{com,gnu}
}
