# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/gnu-javamail/gnu-javamail-20040331.ebuild,v 1.11 2005/09/11 15:41:22 betelgeuse Exp $

inherit java-pkg

DESCRIPTION="GNU implementation of the Javamail API"
HOMEPAGE="http://www.gnu.org/software/classpathx/javamail/"
SRC_URI="http://www.gentoo.org/~karltk/java/distfiles/javamail-${PV}-gentoo.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc jikes"
RDEPEND=">=virtual/jre-1.3
	dev-java/gnu-activation
	=dev-java/gnu-classpath-inetlib-1.0*"
DEPEND=">=virtual/jdk-1.3
	${RDEPEND}
	jikes? ( >=dev-java/jikes-1.19 )"

S=${WORKDIR}/javamail-${PV}

src_compile() {
	# TODO: Add jikes back	
	# TODO: Useflag this
	econf \
		--with-activation-jar=/usr/share/gnu-activation/lib \
		--with-inetlib-jar=/usr/share/gnu-classpath-inetlib-1.0/lib \
		--enable-smtp \
		--enable-imap \
		--enable-pop3 \
		--enable-nntp \
		--enable-mbox \
		--enable-maildir \
		|| die
	einfo "Configure finished. Compiling... Please wait."
	emake || die
	if use doc; then
		emake javadoc || die
	fi
}

src_install() {
	java-pkg_dojar gnumail.jar gnumail-providers.jar || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README README.*
	use doc && java-pkg_dohtml -r docs/*
}
