# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/vm/vm-7.19.282.ebuild,v 1.4 2007/04/19 14:01:13 kloeri Exp $

inherit elisp eutils versionator

VM_PV=$(get_version_component_range 1-2 ${PV})
VM_P=vm-${VM_PV}
PATCH_PV=$(get_version_component_range 3- ${PV})

DESCRIPTION="The VM mail reader for Emacs"
HOMEPAGE="http://www.robf.de/Hacking/elisp/"
SRC_URI="ftp://ftp.uni-mainz.de/pub/software/gnu/vm/${VM_P}.tar.gz
	mirror://gentoo/${P}.patch.gz"
# patch taken from http://www.robf.de/Hacking/elisp/${VM_P}.patch.gz

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~sparc ~x86"
IUSE="bbdb"

DEPEND="bbdb? ( app-emacs/bbdb )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${VM_P}"

SITEFILE=51vm-gentoo.el

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${WORKDIR}/${P}.patch"
	epatch "${FILESDIR}/vm-info-dir-fix-gentoo.patch"

	# extract patchdoc.txt from leading text of patch
	sed -e '1,/^\*\**$/d;/^diff\|^Bin/,$d' "${WORKDIR}/${P}.patch" \
		>patchdoc.txt || die "sed failed"

	# fix vm-version
	sed -i -e '/^  (interactive)/,/^$/c\' \
		-e "  (concat vm-version \"-devo-${PATCH_PV}\"))\n" vm-version.el \
		|| die "sed failed"

	if ! use bbdb; then
		elog "Excluding vm-pcrisis.el since the \"bbdb\" USE flag is not set."
		rm -f vm-pcrisis.*
		sed -i -e '1,/^vm\.info:/s/ vm-pcrisis.info//' Makefile \
			|| die "sed failed"
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" || die "compilation failed"
}

src_install() {
	emake prefix="${D}/usr" \
		INFODIR="${D}/usr/share/info" \
		LISPDIR="${D}${SITELISP}/vm" \
		PIXMAPDIR="${D}/usr/share/pixmaps/vm" \
		install || die "installation failed"

	elisp-install vm *.el
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc README ChangeLog oldChangeLog TODO patchdoc.txt
}
