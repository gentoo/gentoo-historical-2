# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/libidn/libidn-1.0-r1.ebuild,v 1.3 2008/02/05 11:04:00 corsair Exp $

inherit java-pkg-opt-2 mono autotools elisp-common

DESCRIPTION="Internationalized Domain Names (IDN) implementation"
HOMEPAGE="http://www.gnu.org/software/libidn/"
SRC_URI="ftp://alpha.gnu.org/pub/gnu/libidn/${P}.tar.gz"

LICENSE="LGPL-2.1 GPL-3"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 ~mips ~ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="java doc emacs mono nls"

DEPEND="java? ( >=virtual/jdk-1.4
				dev-java/gjdoc
				mono? ( >=dev-lang/mono-0.95 )
		)"
RDEPEND="java? ( >=virtual/jre-1.4 )
		mono? ( >=dev-lang/mono-0.95 )
		emacs? ( virtual/emacs )"

src_compile() {
	local myconf=" --disable-csharp"

	use mono && myconf="--enable-csharp=mono"
	use emacs && myconf="${myconf} --with-lispdir=${SITELISP}/${PN}"

	econf \
		$(use_enable nls) \
		$(use_enable java) \
		${myconf} \
		|| die

	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog FAQ NEWS README THANKS TODO || die

	use emacs || rm -rf "${D}/usr/share/emacs"
	#use xemacs || rm -rf "${D}/usr/lib/xemacs"

	if use doc; then
		dohtml -r doc/reference/html/* || die
	fi

	if use java; then
		java-pkg_newjar "${D}"/usr/share/java/${P}.jar || die
		rm -rf "${D}"/usr/share/java || die

		if use doc; then
			java-pkg_dojavadoc doc/java
		fi
	fi
}

pkg_postinst() {
	if use emacs; then
		elog "activate Emacs support by adding the following lines"
		elog "to your ~/.emacs file:"
		elog "   (add-to-list 'load-path \"${SITELISP}/${PN}\")"
		elog "   (load idna)"
		elog "   (load punycode)"
	fi
}
