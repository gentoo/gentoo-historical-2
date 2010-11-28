# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gtk-doc/gtk-doc-1.15-r2.ebuild,v 1.2 2010/11/28 14:27:19 armin76 Exp $

EAPI="2"
PYTHON_DEPEND="2"

inherit autotools eutils elisp-common gnome2 python

DESCRIPTION="GTK+ Documentation Generator"
HOMEPAGE="http://www.gtk.org/gtk-doc/"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~m68k ~mips ~ppc ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE="debug doc emacs highlight vim test"

# dev-tex/tex4ht blocker needed due bug #315287
RDEPEND=">=dev-libs/glib-2.6
	>=dev-lang/perl-5.6
	>=app-text/openjade-1.3.1
	dev-libs/libxslt
	>=dev-libs/libxml2-2.3.6
	~app-text/docbook-xml-dtd-4.3
	app-text/docbook-xsl-stylesheets
	~app-text/docbook-sgml-dtd-3.0
	>=app-text/docbook-dsssl-stylesheets-1.40
	emacs? ( virtual/emacs )
	highlight? (
		vim? ( app-editors/vim )
		!vim? ( dev-util/source-highlight )
	)
	!!<dev-tex/tex4ht-20090611_p1038-r1"

DEPEND="${RDEPEND}
	~dev-util/gtk-doc-am-${PV}
	>=dev-util/pkgconfig-0.19
	>=app-text/scrollkeeper-0.3.14
	>=app-text/gnome-doc-utils-0.3.2
	test? ( app-text/scrollkeeper-dtd )"

SITEFILE=61${PN}-gentoo.el

pkg_setup() {
	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README TODO"
	if use vim; then
		G2CONF="${G2CONF} $(use_with highlight highlight vim)"
	else
		G2CONF="${G2CONF} $(use_with highlight highlight source-highlight)"
	fi
	python_set_active_version 2
}

src_prepare() {
	gnome2_src_prepare

	# Remove global Emacs keybindings.
	epatch "${FILESDIR}/${PN}-1.8-emacs-keybindings.patch"

	# Fix bug 306569 by not loading vim plugins while calling vim in
	# gtkdoc-fixxref for fixing vim syntax highlighting
	# Also fix incompatibility with vim-7.3 (bug #333313)
	epatch "${FILESDIR}/${PN}-1.15-fixxref-vim-fixes.patch"

	# Allow selection of specific highlighter, bug #334489
	# In upstream's master
	epatch "${FILESDIR}/${PN}-1.15-allow-selection-highlighter.patch"

	eautoreconf
}

src_compile() {
	gnome2_src_compile

	use emacs && elisp-compile tools/gtk-doc.el
}

src_install() {
	gnome2_src_install

	python_convert_shebangs 2 "${D}"/usr/bin/gtkdoc-depscan

	# Don't install those files, they are in gtk-doc-am now
	rm "${D}"/usr/share/aclocal/gtk-doc.m4 || die "failed to remove gtk-doc.m4"
	rm "${D}"/usr/bin/gtkdoc-rebase || die "failed to remove gtkdoc-rebase"

	if use doc; then
		docinto doc
		dodoc doc/*
		docinto examples
		dodoc examples/*
	fi

	if use emacs; then
		elisp-install ${PN} tools/gtk-doc.el*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		elog "gtk-doc does no longer define global key bindings for Emacs."
		elog "You may set your own key bindings for \"gtk-doc-insert\" and"
		elog "\"gtk-doc-insert-section\" in your ~/.emacs file."
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
