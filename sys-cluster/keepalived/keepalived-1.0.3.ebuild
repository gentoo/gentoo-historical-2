DESCRIPTION="The main goal of the keepalived project is to add a strong & robust keepalive facility to the Linux Virtual Server project."
HOMEPAGE="http://keepalived.sourceforge.net"
LICENSE="GPL-2"
DEPEND="virtual/linux-sources
	popt"

SRC_URI="http://keepalived.sourceforge.net/software/${P}.tar.gz"

IUSE=""
SLOT="0"
KEYWORDS="~x86"
S="${WORKDIR}/${P}"

src_compile() {
	cd "${S}"
	./configure --prefix=/
	make || die
}

src_install() {

	cd "${S}"
	einstall	

	exeinto /etc/init.d
	newexe ${FILESDIR}/init-keepalived keepalived

}

pkg_postinst() {

	einfo ""
	einfo "If you want Linux Virtual Server support in"
	einfo "keepalived then you must emerge an LVS patched" 
	einfo "kernel like gentoo-sources, compile with ipvs"
	einfo "support either as a module or built into the"
	einfo "kernel, emerge the ipvsadm userland tools,"
	einfo "and reemerge keepalived."
	einfo ""

}
