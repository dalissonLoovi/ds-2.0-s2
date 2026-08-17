declare module '@figma/code-connect' {
  type EnumMap = Record<string, string>;
  interface FigmaConnectApi {
    connect: (
      component: unknown,
      url: string,
      config: {
        props?: Record<string, unknown>;
        example: (props: Record<string, unknown>) => unknown;
      },
    ) => void;
    string: (name: string) => unknown;
    boolean: (name: string) => unknown;
    enum: (name: string, map: EnumMap) => unknown;
  }
  const figma: FigmaConnectApi;
  export default figma;
}
