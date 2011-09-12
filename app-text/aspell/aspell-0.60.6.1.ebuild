# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/aspell/aspell-0.60.6.1.ebuild,v 1.1 2011/09/12 06:16:05 pva Exp $

EAPI="4"

inherit libtool eutils flag-o-matic autotools

DESCRIPTION="A spell checker replacement for ispell"
HOMEPAGE="http://aspell.net/"
SRC_URI="mirror://gnu/aspell/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="nls"

# Build PDEPEND from list of language codes provided in the tree.
# The PDEPEND string is static - this code just makes it easier to maintain.
def="app-dicts/aspell-en"
for l in \
	"af" "be" "bg" "br" "ca" "cs" "cy" "da" "de" "el" \
	"en" "eo" "es" "et" "fi" "fo" "fr" "ga" "gl" "he" \
	"hr" "is" "it" "la" "lt" "nl" "no" "pl" "pt" "pt_BR" \
	"ro" "ru" "sk" "sl" "sr" "sv" "uk" "vi" ; do
	dep="linguas_${l}? ( app-dicts/aspell-${l/pt_BR/pt-br} )"
	[[ ${l} = "de" ]] &&
		dep="linguas_de? ( || ( app-dicts/aspell-de app-dicts/aspell-de-alt ) )"
	[[ -z ${PDEPEND} ]] &&
		PDEPEND="${dep}" ||
		PDEPEND="${PDEPEND}
${dep}"
	def="!linguas_${l}? ( ${def} )"
	IUSE="${IUSE} linguas_${l}"
done
PDEPEND="${PDEPEND}
${def}"

COMMON_DEPEND=">=sys-libs/ncurses-5.2
	nls? ( virtual/libintl )"

DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )"

# English dictionary 0.5 is incompatible with aspell-0.6
RDEPEND="${COMMON_DEPEND}
	!=app-dicts/aspell-en-0.5*"

src_prepare() {
	#epatch "${FILESDIR}/${PN}-0.60.3-templateinstantiations.patch"
	epatch "${FILESDIR}/${PN}-0.60.5-nls.patch"
	epatch "${FILESDIR}/${PN}-0.60.5-solaris.patch"
	epatch "${FILESDIR}/${PN}-0.60.6-darwin-bundles.patch"

	rm m4/lt* m4/libtool.m4
	eautoreconf
	elibtoolize --reverse-deps
}

src_configure() {
	econf \
		$(use_enable nls) \
		--disable-static \
		--sysconfdir="${EPREFIX}"/etc/aspell \
		--enable-docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc README* TODO
	dohtml -r manual/aspell{,-dev}.html
	docinto examples
	dodoc "${S}"/examples/*.c

	# install ispell/aspell compatibility scripts
	exeinto /usr/bin
	newexe scripts/ispell ispell-aspell
	newexe scripts/spell spell-aspell

	find "${ED}" -name '*.la' -exec rm -f {} +
}

pkg_postinst() {
	elog "In case LINGUAS was not set correctly you may need to install"
	elog "dictionaries now. Please choose an aspell-<LANG> dictionary or"
	elog "set LINGUAS correctly and let aspell pull in required packages."
	elog "After installing an aspell dictionary for your language(s),"
	elog "You may use the aspell-import utility to import your personal"
	elog "dictionaries from ispell, pspell and the older aspell"
}
